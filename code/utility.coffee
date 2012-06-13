_            = require('underscore')

# :todo: (exercise for reader) rewrite with O(n) complexity
# Minimal EXcluded.
# Given a set of numbers (non-negative integers), return the Minimal Excluded
# number, which is the smallest number that is not in the set.
# For example, mex([0,1,5]) == 2
exports.mex = (l) ->
  _.min(i for i in [0..l.length] when i not in l)
