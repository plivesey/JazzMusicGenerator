//
//  AccurateDispatchTimer.swift
//  TestAudio
//
//  Created by Peter Livesey on 6/15/14.
//  Copyright (c) 2014 Peter Livesey. All rights reserved.
//

import Foundation

func dispatchAccuratelyAfter(delay: Float, #queue: dispatch_queue_t, block: dispatch_block_t) {
  var timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
  // Should use a constant for this but it doesn't seem to work in swift yet
  let dispatchDelay = Int64(delay * 1_000_000_000)
  // Use forever to denote no repeat
  dispatch_source_set_timer(timer, dispatch_walltime(nil, dispatchDelay), DISPATCH_TIME_FOREVER, 0)
  dispatch_source_set_event_handler(timer) {
    block()
    // We need to keep a reference to the timer as long as the block stays around. 
    // Once the block excecutes, we can clean up the timer memory
    // I'm pretty sure this isn't nil, and I could just put the line: "timer" here, but this seems more readable
    timer = nil
  }
  dispatch_resume(timer)
}
