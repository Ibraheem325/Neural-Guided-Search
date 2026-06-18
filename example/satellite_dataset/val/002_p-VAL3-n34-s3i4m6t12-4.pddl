(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	instrument4 - instrument
	instrument5 - instrument
	infrared2 - mode
	infrared4 - mode
	infrared1 - mode
	image5 - mode
	thermograph0 - mode
	image3 - mode
	Star0 - direction
	GroundStation9 - direction
	GroundStation4 - direction
	Star11 - direction
	GroundStation2 - direction
	GroundStation10 - direction
	Star7 - direction
	GroundStation6 - direction
	Star1 - direction
	Star3 - direction
	Star5 - direction
	GroundStation8 - direction
	Planet12 - direction
	Star13 - direction
	Planet14 - direction
	Phenomenon15 - direction
)
(:init
	(supports instrument0 image5)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 GroundStation4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star13)
	(supports instrument1 infrared1)
	(supports instrument1 infrared4)
	(calibration_target instrument1 Star5)
	(calibration_target instrument1 Star11)
	(supports instrument2 thermograph0)
	(supports instrument2 image5)
	(calibration_target instrument2 Star5)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 Star1)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star7)
	(supports instrument3 infrared1)
	(supports instrument3 infrared2)
	(calibration_target instrument3 GroundStation10)
	(calibration_target instrument3 GroundStation8)
	(supports instrument4 image5)
	(supports instrument4 image3)
	(supports instrument4 infrared2)
	(calibration_target instrument4 Star1)
	(calibration_target instrument4 GroundStation6)
	(calibration_target instrument4 Star7)
	(supports instrument5 infrared4)
	(calibration_target instrument5 GroundStation8)
	(calibration_target instrument5 Star5)
	(calibration_target instrument5 Star3)
	(on_board instrument3 satellite2)
	(on_board instrument4 satellite2)
	(on_board instrument5 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star1)
)
(:goal (and
	(pointing satellite2 Phenomenon15)
	(have_image Planet12 infrared4)
	(have_image Planet12 image3)
	(have_image Star13 image5)
	(have_image Planet14 thermograph0)
	(have_image Planet14 infrared1)
	(have_image Phenomenon15 image5)
))

)
