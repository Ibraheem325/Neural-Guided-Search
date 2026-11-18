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
	satellite5 - satellite
	instrument5 - instrument
	image0 - mode
	Star0 - direction
	Star1 - direction
	Star6 - direction
	GroundStation7 - direction
	Star10 - direction
	Star11 - direction
	Star12 - direction
	GroundStation13 - direction
	GroundStation14 - direction
	Star18 - direction
	Star19 - direction
	Star21 - direction
	GroundStation22 - direction
	Star24 - direction
	Star25 - direction
	Star27 - direction
	GroundStation31 - direction
	Star16 - direction
	Star2 - direction
	Star17 - direction
	GroundStation5 - direction
	GroundStation20 - direction
	GroundStation30 - direction
	Star4 - direction
	Star26 - direction
	Star28 - direction
	GroundStation3 - direction
	GroundStation23 - direction
	GroundStation29 - direction
	Star15 - direction
	GroundStation8 - direction
	Star9 - direction
	Planet32 - direction
	Star33 - direction
	Star34 - direction
	Planet35 - direction
	Star36 - direction
	Planet37 - direction
	Star38 - direction
	Planet39 - direction
	Planet40 - direction
	Phenomenon41 - direction
	Planet42 - direction
	Phenomenon43 - direction
	Star44 - direction
	Phenomenon45 - direction
	Star46 - direction
	Planet47 - direction
	Phenomenon48 - direction
)
(:init
	(supports instrument0 image0)
	(calibration_target instrument0 Star16)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star4)
	(supports instrument1 image0)
	(calibration_target instrument1 Star15)
	(calibration_target instrument1 GroundStation29)
	(calibration_target instrument1 GroundStation30)
	(calibration_target instrument1 GroundStation20)
	(calibration_target instrument1 GroundStation5)
	(calibration_target instrument1 Star17)
	(calibration_target instrument1 Star2)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star10)
	(supports instrument2 image0)
	(calibration_target instrument2 Star4)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star19)
	(supports instrument3 image0)
	(calibration_target instrument3 Star15)
	(calibration_target instrument3 GroundStation29)
	(calibration_target instrument3 GroundStation23)
	(calibration_target instrument3 GroundStation3)
	(calibration_target instrument3 Star28)
	(calibration_target instrument3 Star26)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation20)
	(supports instrument4 image0)
	(calibration_target instrument4 GroundStation8)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star25)
	(supports instrument5 image0)
	(calibration_target instrument5 Star9)
	(on_board instrument5 satellite5)
	(power_avail satellite5)
	(pointing satellite5 GroundStation5)
)
(:goal (and
	(pointing satellite1 GroundStation14)
	(pointing satellite4 Planet32)
	(pointing satellite5 Phenomenon48)
	(have_image Planet32 image0)
	(have_image Star33 image0)
	(have_image Star34 image0)
	(have_image Planet35 image0)
	(have_image Star36 image0)
	(have_image Planet37 image0)
	(have_image Star38 image0)
	(have_image Planet39 image0)
	(have_image Planet40 image0)
	(have_image Phenomenon41 image0)
	(have_image Planet42 image0)
	(have_image Phenomenon43 image0)
	(have_image Star44 image0)
	(have_image Phenomenon45 image0)
	(have_image Star46 image0)
	(have_image Planet47 image0)
	(have_image Phenomenon48 image0)
))

)
