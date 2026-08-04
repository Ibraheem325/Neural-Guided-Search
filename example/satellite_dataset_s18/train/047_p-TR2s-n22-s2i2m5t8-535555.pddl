(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	infrared0 - mode
	infrared1 - mode
	thermograph4 - mode
	thermograph3 - mode
	infrared2 - mode
	Star1 - direction
	GroundStation3 - direction
	Star5 - direction
	GroundStation7 - direction
	Star4 - direction
	Star0 - direction
	GroundStation6 - direction
	GroundStation2 - direction
	Planet8 - direction
	Planet9 - direction
	Planet10 - direction
	Phenomenon11 - direction
)
(:init
	(supports instrument0 thermograph4)
	(supports instrument0 infrared0)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 Star4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation7)
	(supports instrument1 thermograph4)
	(supports instrument1 infrared1)
	(supports instrument1 thermograph3)
	(calibration_target instrument1 Star0)
	(supports instrument2 thermograph4)
	(supports instrument2 infrared2)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 GroundStation6)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon11)
)
(:goal (and
	(pointing satellite0 Planet9)
	(pointing satellite1 GroundStation2)
	(have_image Planet8 thermograph4)
	(have_image Planet9 infrared0)
	(have_image Planet10 infrared1)
	(have_image Phenomenon11 infrared0)
))

)
