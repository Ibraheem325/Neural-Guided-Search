(define (problem grid-v2-parallel)
(:domain grid)
(:objects 
        f0-0f f1-0f f2-0f f3-0f f4-0f f5-0f fA-0f fB-0f 
        shape0 shape1 shape2 shape3 shape4 shape5 shape6 shape7 
        keyA keyB keyC keyD keyE keyF keyG keyH 
)
(:init
(arm-empty)
(place f0-0f)(place f1-0f)(place f2-0f)(place f3-0f)(place f4-0f)(place f5-0f)(place fA-0f)(place fB-0f)
(shape shape0)(shape shape1)(shape shape2)(shape shape3)(shape shape4)(shape shape5)(shape shape6)(shape shape7)
(key keyA)(key keyB)(key keyC)(key keyD)(key keyE)(key keyF)(key keyG)(key keyH)
(key-shape keyA shape0)(key-shape keyB shape1)(key-shape keyC shape2)(key-shape keyD shape3)
(key-shape keyE shape4)(key-shape keyF shape5)(key-shape keyG shape6)(key-shape keyH shape7)
(conn f0-0f f1-0f)(conn f1-0f f0-0f)(conn f1-0f f2-0f)(conn f2-0f f1-0f)(conn f2-0f f3-0f)(conn f3-0f f2-0f)
(conn f3-0f f4-0f)(conn f4-0f f3-0f)(conn f4-0f f5-0f)(conn f5-0f f4-0f)
(conn f5-0f fA-0f)(conn fA-0f f5-0f)(conn f5-0f fB-0f)(conn fB-0f f5-0f)
(open f0-0f)(open f1-0f)(open f2-0f)(open f3-0f)(open f4-0f)(open f5-0f)
(locked fA-0f)(locked fB-0f)
(lock-shape fA-0f shape3)(lock-shape fB-0f shape5)
(at keyA f5-0f)(at keyB f5-0f)(at keyC f5-0f)(at keyD f5-0f)(at keyE f5-0f)(at keyF f5-0f)(at keyG f5-0f)(at keyH f5-0f)
(at-robot f0-0f)
)
(:goal (and (at keyD fA-0f) (at keyF fB-0f)))
)
