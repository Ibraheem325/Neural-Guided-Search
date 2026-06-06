(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	thermograph2 - mode
	image0 - mode
	infrared1 - mode
	Star0 - direction
	Star2 - direction
	Star6 - direction
	GroundStation8 - direction
	Star10 - direction
	Star12 - direction
	GroundStation14 - direction
	GroundStation7 - direction
	GroundStation13 - direction
	Star9 - direction
	Star4 - direction
	Star11 - direction
	Star3 - direction
	GroundStation5 - direction
	Star1 - direction
	Planet15 - direction
	Planet16 - direction
	Planet17 - direction
	Planet18 - direction
	Phenomenon19 - direction
	Planet20 - direction
	Planet21 - direction
	Phenomenon22 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 image0)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 GroundStation13)
	(calibration_target instrument0 Star3)
	(calibration_target instrument0 GroundStation7)
	(supports instrument1 thermograph2)
	(calibration_target instrument1 Star4)
	(calibration_target instrument1 Star11)
	(calibration_target instrument1 GroundStation5)
	(calibration_target instrument1 Star9)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet18)
	(supports instrument2 infrared1)
	(supports instrument2 thermograph2)
	(supports instrument2 image0)
	(calibration_target instrument2 Star11)
	(calibration_target instrument2 Star4)
	(supports instrument3 thermograph2)
	(calibration_target instrument3 Star1)
	(calibration_target instrument3 GroundStation5)
	(calibration_target instrument3 Star3)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet15)
)
(:goal (and
	(pointing satellite0 Star3)
	(pointing satellite1 Star6)
	(have_image Planet15 thermograph2)
	(have_image Planet16 image0)
	(have_image Planet17 infrared1)
	(have_image Planet18 image0)
	(have_image Phenomenon19 infrared1)
	(have_image Planet20 infrared1)
	(have_image Planet21 image0)
	(have_image Phenomenon22 thermograph2)
))

)
