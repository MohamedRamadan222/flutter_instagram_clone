/// Pure feed layout math (P0-3, P6-4).
///
/// The home feed interleaves two special sections (suggested users, threads)
/// into the post list at fixed random slots. The math is extracted here so it
/// can be unit-tested and shared.
library;

/// Slots below zero mark special sections.
const int feedSlotSuggested = -1;
const int feedSlotThreads = -2;

/// Resolves a flat feed slot to either a special-section marker or the index
/// of the post rendered there. The caller must additionally guard the
/// returned index against the current post count.
///
/// Requires [suggestedIndex] != [threadsIndex] and both >= 0.
int feedSlotIndex(
  int index, {
  required int suggestedIndex,
  required int threadsIndex,
}) {
  assert(suggestedIndex >= 0, 'suggestedIndex must be >= 0');
  assert(threadsIndex >= 0, 'threadsIndex must be >= 0');
  assert(
    suggestedIndex != threadsIndex,
    'special sections must occupy distinct slots',
  );
  if (index == suggestedIndex) return feedSlotSuggested;
  if (index == threadsIndex) return feedSlotThreads;
  var insertedBefore = 0;
  if (index > suggestedIndex) insertedBefore++;
  if (index > threadsIndex) insertedBefore++;
  return index - insertedBefore;
}

/// Total sliver slots for [postCount] posts plus the two special sections.
int feedSlotCount(int postCount) {
  assert(postCount >= 0, 'postCount must be >= 0');
  return postCount + 2;
}