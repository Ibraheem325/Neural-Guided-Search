(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	instrument4 - instrument
	infrared2 - mode
	infrared1 - mode
	image5 - mode
	thermograph0 - mode
	image3 - mode
	infrared4 - mode
	Star1 - direction
	Star5 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	Star11 - direction
	GroundStation12 - direction
	Star0 - direction
	GroundStation13 - direction
	GroundStation6 - direction
	GroundStation4 - direction
	Star7 - direction
	GroundStation2 - direction
	Star3 - direction
	Planet14 - direction
	Star15 - direction
	Planet16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 infrared1)
	(calibration_target instrument0 Star7)
	(supports instrument1 image3)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 GroundStation2)
	(calibration_target instrument1 GroundStation13)
	(calibration_target instrument1 Star0)
	(supports instrument2 thermograph0)
	(supports instrument2 image3)
	(supports instrument2 infrared1)
	(calibration_target instrument2 GroundStation4)
	(calibration_target instrument2 GroundStation6)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 Star7)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation9)
	(supports instrument3 infrared1)
	(supports instrument3 image3)
	(supports instrument3 thermograph0)
	(calibration_target instrument3 GroundStation2)
	(calibration_target instrument3 Star7)
	(supports instrument4 image5)
	(supports instrument4 infrared2)
	(supports instrument4 infrared4)
	(calibration_target instrument4 Star3)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation2)
)
(:goal (and
	(pointing satellite1 Planet14)
	(have_image Planet14 image5)
	(have_image Star15 infrared1)
	(have_image Planet16 infrared1)
	(have_image Planet17 infrared4)
	(have_image Planet17 infrared2)
))

)
