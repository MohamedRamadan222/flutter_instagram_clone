-- Supabase schema for the Instagram clone (Phase 5, P5-2).
-- Run in the SQL editor of a new project. Maps 1:1 to 03_DATA_CONTRACTS.md.

-- ---------------------------------------------------------------------------
-- Extensions
-- ---------------------------------------------------------------------------
create extension if not exists pgcrypto;

-- ---------------------------------------------------------------------------
-- Tables
-- ---------------------------------------------------------------------------

-- users: contract `username, profilePic, name, bio, followers, following`
create table users (
  id            uuid primary key default gen_random_uuid(),
  username      text unique not null,
  display_name  text not null default '',
  avatar_url    text not null default '',
  bio           text not null default '',
  created_at    timestamptz not null default now()
);

-- posts: contract `id, username, name, profilePic, location?, isFollowing,
-- media[], likes, caption, comments, reposts, shares, timeAgo, isSponsored`
create table posts (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references users(id) on delete cascade,
  caption       text not null default '',
  location      text,
  is_sponsored  boolean not null default false,
  created_at    timestamptz not null default now()
);

create table post_media (
  id          uuid primary key default gen_random_uuid(),
  post_id     uuid not null references posts(id) on delete cascade,
  media_type  text not null check (media_type in ('image', 'video')),
  url         text not null,
  position    int  not null default 0,
  reel_id     uuid, -- links a video post to a reel
  created_at  timestamptz not null default now()
);

-- stories: contract `username, profileImage, isSeen, stories[{imageUrl}]`
create table stories (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references users(id) on delete cascade,
  image_url   text not null,
  expires_at  timestamptz not null default now() + interval '24 hours',
  created_at  timestamptz not null default now()
);

-- reels: contract `id, username, profilePic, videoUrl, caption, likes,
-- comments, audioTitle, isFollowing`
create table reels (
  id             uuid primary key default gen_random_uuid(),
  user_id        uuid not null references users(id) on delete cascade,
  video_url      text not null,
  caption        text not null default '',
  audio_title    text not null default 'Original Audio',
  likes_count    int  not null default 0,
  comments_count int  not null default 0,
  created_at     timestamptz not null default now()
);

-- threads: contract `id, username, profilePic, timeAgo, text, likes,
-- replies, reposts, image?, isVerified`
create table threads (
  id            uuid primary key default gen_random_uuid(),
  user_id       uuid not null references users(id) on delete cascade,
  text          text not null,
  image_url     text,
  likes_count   int not null default 0,
  replies_count int not null default 0,
  reposts_count int not null default 0,
  created_at    timestamptz not null default now()
);

-- comments: contract `commentsData[{username, profilePic, comment, likes, time}]`
create table comments (
  id         uuid primary key default gen_random_uuid(),
  post_id    uuid references posts(id) on delete cascade,
  reel_id    uuid references reels(id) on delete cascade,
  user_id    uuid not null references users(id) on delete cascade,
  text       text not null,
  created_at timestamptz not null default now(),
  check (post_id is not null or reel_id is not null)
);

create table follows (
  follower_id  uuid not null references users(id) on delete cascade,
  following_id uuid not null references users(id) on delete cascade,
  created_at   timestamptz not null default now(),
  primary key (follower_id, following_id)
);

create table post_likes (
  post_id    uuid not null references posts(id) on delete cascade,
  user_id    uuid not null references users(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (post_id, user_id)
);

create table reel_likes (
  reel_id    uuid not null references reels(id) on delete cascade,
  user_id    uuid not null references users(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (reel_id, user_id)
);

create table thread_likes (
  thread_id  uuid not null references threads(id) on delete cascade,
  user_id    uuid not null references users(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (thread_id, user_id)
);

create table saves (
  post_id    uuid not null references posts(id) on delete cascade,
  user_id    uuid not null references users(id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (post_id, user_id)
);

-- messages: contract `chatId, username, profilePic, lastMessage, timeAgo,
-- unread, messages[{fromMe, text, time}]`
create table messages (
  id          uuid primary key default gen_random_uuid(),
  sender_id   uuid not null references users(id) on delete cascade,
  receiver_id uuid not null references users(id) on delete cascade,
  text        text not null,
  read_at     timestamptz,
  created_at  timestamptz not null default now()
);

-- notifications: contract `type, username, profilePic, text, timeAgo, previewImage?`
create table notifications (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null references users(id) on delete cascade, -- recipient
  actor_id    uuid not null references users(id) on delete cascade, -- who acted
  type        text not null check (type in ('like', 'follow', 'comment')),
  post_id     uuid references posts(id) on delete cascade,
  text        text not null default '',
  read_at     timestamptz,
  created_at  timestamptz not null default now()
);

create index posts_created_idx on posts (created_at desc);
create index post_media_post_idx on post_media (post_id);
create index comments_post_idx on comments (post_id);
create index messages_pair_idx on messages (sender_id, receiver_id, created_at);
create index notifications_user_idx on notifications (user_id, created_at desc);

-- ---------------------------------------------------------------------------
-- Count maintenance (reels likes/comments, threads likes)
-- ---------------------------------------------------------------------------

create or replace function bump_reel_likes() returns trigger as $$
begin
  if tg_op = 'INSERT' then
    update reels set likes_count = likes_count + 1 where id = NEW.reel_id;
  elsif tg_op = 'DELETE' then
    update reels set likes_count = greatest(likes_count - 1, 0) where id = OLD.reel_id;
  end if;
  return null;
end $$ language plpgsql;

create trigger reel_likes_bump after insert or delete on reel_likes
  for each row execute function bump_reel_likes();

create or replace function bump_reel_comments() returns trigger as $$
begin
  if tg_op = 'INSERT' then
    update reels set comments_count = comments_count + 1 where id = NEW.reel_id;
  elsif tg_op = 'DELETE' then
    update reels set comments_count = greatest(comments_count - 1, 0) where id = OLD.reel_id;
  end if;
  return null;
end $$ language plpgsql;

create trigger reel_comments_bump after insert or delete on comments
  for each row when (NEW.reel_id is not null)
  execute function bump_reel_comments();

create or replace function bump_thread_likes() returns trigger as $$
begin
  if tg_op = 'INSERT' then
    update threads set likes_count = likes_count + 1 where id = NEW.thread_id;
  elsif tg_op = 'DELETE' then
    update threads set likes_count = greatest(likes_count - 1, 0) where id = OLD.thread_id;
  end if;
  return null;
end $$ language plpgsql;

create trigger thread_likes_bump after insert or delete on thread_likes
  for each row execute function bump_thread_likes();

-- ---------------------------------------------------------------------------
-- Storage buckets
-- ---------------------------------------------------------------------------

insert into storage.buckets (id, name, public)
values ('avatars', 'avatars', true),
       ('posts',   'posts',   true),
       ('stories', 'stories', true),
       ('reels',   'reels',   true)
on conflict (id) do nothing;

-- ---------------------------------------------------------------------------
-- RLS — NOTE: open to the `anon` role for the demo (no auth yet). Replace
-- `to anon` with `to authenticated` and add `auth.uid() = user_id` checks
-- once Supabase Auth is wired (Phase 5 follow-up).
-- ---------------------------------------------------------------------------

alter table users         enable row level security;
alter table posts         enable row level security;
alter table post_media    enable row level security;
alter table stories       enable row level security;
alter table reels         enable row level security;
alter table threads       enable row level security;
alter table comments      enable row level security;
alter table follows       enable row level security;
alter table post_likes    enable row level security;
alter table reel_likes    enable row level security;
alter table thread_likes  enable row level security;
alter table saves         enable row level security;
alter table messages      enable row level security;
alter table notifications enable row level security;

do $$
declare t text;
begin
  foreach t in array
    array['users','posts','post_media','stories','reels','threads','comments',
          'follows','post_likes','reel_likes','thread_likes','saves',
          'messages','notifications']
  loop
    execute format(
      'create policy "anon_all_%s" on %I for all to anon using (true) with check (true)',
      t, t);
  end loop;
end $$;

-- Storage: allow the app to upload/read demo media.
create policy "anon_storage_all" on storage.objects
  for all to anon using (bucket_id in ('avatars','posts','stories','reels'))
  with check (bucket_id in ('avatars','posts','stories','reels'));

-- ---------------------------------------------------------------------------
-- Realtime: subscribe so two devices converge on refresh
-- ---------------------------------------------------------------------------

alter publication supabase_realtime add table posts;
alter publication supabase_realtime add table post_media;
alter publication supabase_realtime add table comments;
alter publication supabase_realtime add table follows;
alter publication supabase_realtime add table post_likes;
alter publication supabase_realtime add table saves;
alter publication supabase_realtime add table messages;
alter publication supabase_realtime add table notifications;