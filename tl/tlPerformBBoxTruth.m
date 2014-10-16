function isTrue = tlPerformBBoxTruth(trueBBox, positiveBBox, overlapType, overlapMin)

  switch overlapType
  case 'IoU'
    isTrue = (overlapMin <= tlBBoxOverlap(trueBBox, positiveBBox, 'union'));
  case 'IntOverPositive'
    isTrue = (overlapMin <= tlBBoxOverlap(trueBBox, positiveBBox, 'bbox2'));
  end

end