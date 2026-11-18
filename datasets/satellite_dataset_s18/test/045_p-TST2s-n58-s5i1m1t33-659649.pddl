(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	satellite3 - satellite
	instrument3 - instrument
	satellite4 - satellite
	instrument4 - instrument
	image0 - mode
	GroundStation1 - direction
	GroundStation3 - direction
	Star5 - direction
	Star6 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	Star12 - direction
	Star19 - direction
	Star20 - direction
	Star28 - direction
	Star30 - direction
	GroundStation32 - direction
	Star27 - direction
	GroundStation29 - direction
	Star2 - direction
	Star8 - direction
	GroundStation16 - direction
	Star17 - direction
	GroundStation11 - direction
	GroundStation0 - direction
	GroundStation13 - direction
	GroundStation7 - direction
	GroundStation14 - direction
	GroundStation26 - direction
	Star25 - direction
	GroundStation24 - direction
	Star21 - direction
	GroundStation23 - direction
	GroundStation4 - direction
	Star15 - direction
	GroundStation18 - direction
	Star22 - direction
	GroundStation31 - direction
	Star33 - direction
	Phenomenon34 - direction
	Phenomenon35 - direction
	Star36 - direction
	Phenomenon37 - direction
	Planet38 - direction
	Phenomenon39 - direction
	Planet40 - direction
	Star41 - direction
	Star42 - direction
	Phenomenon43 - direction
	Planet44 - direction
	Planet45 - direction
	Star46 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 Star27)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation13)
	(supports instrument1 image0)
	(calibration_target instrument1 GroundStation14)
	(calibration_target instrument1 Star21)
	(calibration_target instrument1 GroundStation11)
	(calibration_target instrument1 GroundStation29)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation14)
	(supports instrument2 image0)
	(calibration_target instrument2 GroundStation13)
	(calibration_target instrument2 GroundStation0)
	(calibration_target instrument2 GroundStation31)
	(calibration_target instrument2 GroundStation11)
	(calibration_target instrument2 Star17)
	(calibration_target instrument2 GroundStation14)
	(calibration_target instrument2 GroundStation16)
	(calibration_target instrument2 Star8)
	(calibration_target instrument2 Star2)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Phenomenon34)
	(supports instrument3 image0)
	(calibration_target instrument3 GroundStation4)
	(calibration_target instrument3 GroundStation23)
	(calibration_target instrument3 Star21)
	(calibration_target instrument3 GroundStation24)
	(calibration_target instrument3 Star25)
	(calibration_target instrument3 GroundStation26)
	(calibration_target instrument3 GroundStation18)
	(calibration_target instrument3 GroundStation31)
	(calibration_target instrument3 Star22)
	(calibration_target instrument3 GroundStation14)
	(calibration_target instrument3 GroundStation7)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation3)
	(supports instrument4 image0)
	(calibration_target instrument4 GroundStation31)
	(calibration_target instrument4 Star22)
	(calibration_target instrument4 GroundStation18)
	(calibration_target instrument4 Star15)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 GroundStation32)
)
(:goal (and
	(pointing satellite0 Star19)
	(pointing satellite3 GroundStation23)
	(pointing satellite4 Star8)
	(have_image Star33 image0)
	(have_image Phenomenon34 image0)
	(have_image Phenomenon35 image0)
	(have_image Star36 image0)
	(have_image Phenomenon37 image0)
	(have_image Planet38 image0)
	(have_image Phenomenon39 image0)
	(have_image Planet40 image0)
	(have_image Star41 image0)
	(have_image Star42 image0)
	(have_image Phenomenon43 image0)
	(have_image Planet44 image0)
	(have_image Planet45 image0)
	(have_image Star46 image0)
))

)
