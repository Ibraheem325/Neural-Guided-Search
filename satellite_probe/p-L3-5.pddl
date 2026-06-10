(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	instrument3 - instrument
	image0 - mode
	infrared3 - mode
	thermograph2 - mode
	infrared1 - mode
	Star1 - direction
	GroundStation2 - direction
	Star4 - direction
	Star12 - direction
	Star14 - direction
	GroundStation16 - direction
	Star17 - direction
	GroundStation18 - direction
	GroundStation9 - direction
	Star13 - direction
	Star19 - direction
	Star11 - direction
	Star6 - direction
	Star5 - direction
	GroundStation10 - direction
	Star0 - direction
	GroundStation7 - direction
	Star3 - direction
	Star15 - direction
	Star8 - direction
	Star20 - direction
	Star21 - direction
	Phenomenon22 - direction
	Star23 - direction
	Planet24 - direction
	Phenomenon25 - direction
	Planet26 - direction
	Planet27 - direction
	Star28 - direction
	Planet29 - direction
	Phenomenon30 - direction
	Planet31 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 thermograph2)
	(supports instrument0 image0)
	(calibration_target instrument0 Star13)
	(calibration_target instrument0 Star0)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 Star3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation18)
	(supports instrument1 infrared3)
	(supports instrument1 infrared1)
	(calibration_target instrument1 Star6)
	(calibration_target instrument1 GroundStation7)
	(calibration_target instrument1 Star19)
	(supports instrument2 thermograph2)
	(supports instrument2 image0)
	(supports instrument2 infrared3)
	(calibration_target instrument2 Star5)
	(calibration_target instrument2 GroundStation10)
	(calibration_target instrument2 Star6)
	(calibration_target instrument2 Star15)
	(calibration_target instrument2 Star11)
	(supports instrument3 infrared1)
	(supports instrument3 thermograph2)
	(calibration_target instrument3 Star8)
	(calibration_target instrument3 Star15)
	(calibration_target instrument3 Star3)
	(calibration_target instrument3 GroundStation7)
	(calibration_target instrument3 Star0)
	(calibration_target instrument3 GroundStation10)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star28)
)
(:goal (and
	(pointing satellite1 Planet26)
	(have_image Star20 infrared1)
	(have_image Star21 infrared1)
	(have_image Phenomenon22 infrared3)
	(have_image Star23 infrared1)
	(have_image Planet24 image0)
	(have_image Phenomenon25 image0)
	(have_image Planet26 thermograph2)
	(have_image Planet27 infrared3)
	(have_image Star28 infrared1)
	(have_image Planet29 thermograph2)
	(have_image Phenomenon30 infrared3)
	(have_image Planet31 thermograph2)
))

)
