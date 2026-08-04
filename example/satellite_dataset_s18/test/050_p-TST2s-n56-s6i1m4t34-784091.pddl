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
	thermograph1 - mode
	thermograph0 - mode
	thermograph3 - mode
	thermograph2 - mode
	Star0 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation5 - direction
	Star7 - direction
	Star12 - direction
	GroundStation15 - direction
	Star21 - direction
	GroundStation22 - direction
	GroundStation24 - direction
	GroundStation29 - direction
	Star31 - direction
	Star17 - direction
	GroundStation14 - direction
	Star4 - direction
	Star13 - direction
	GroundStation30 - direction
	GroundStation9 - direction
	Star27 - direction
	GroundStation1 - direction
	GroundStation18 - direction
	GroundStation11 - direction
	Star6 - direction
	Star25 - direction
	Star20 - direction
	GroundStation16 - direction
	Star23 - direction
	GroundStation19 - direction
	Star26 - direction
	Star8 - direction
	GroundStation32 - direction
	GroundStation28 - direction
	GroundStation10 - direction
	GroundStation33 - direction
	Phenomenon34 - direction
	Phenomenon35 - direction
	Planet36 - direction
	Phenomenon37 - direction
	Star38 - direction
	Planet39 - direction
)
(:init
	(supports instrument0 thermograph3)
	(supports instrument0 thermograph2)
	(calibration_target instrument0 GroundStation18)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 Star17)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation18)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 GroundStation9)
	(calibration_target instrument1 Star27)
	(calibration_target instrument1 GroundStation11)
	(calibration_target instrument1 GroundStation32)
	(calibration_target instrument1 GroundStation33)
	(calibration_target instrument1 GroundStation30)
	(calibration_target instrument1 Star13)
	(calibration_target instrument1 Star4)
	(calibration_target instrument1 GroundStation10)
	(calibration_target instrument1 GroundStation14)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star38)
	(supports instrument2 thermograph2)
	(calibration_target instrument2 GroundStation11)
	(calibration_target instrument2 GroundStation18)
	(calibration_target instrument2 Star23)
	(calibration_target instrument2 Star8)
	(calibration_target instrument2 GroundStation28)
	(calibration_target instrument2 Star20)
	(calibration_target instrument2 GroundStation1)
	(calibration_target instrument2 Star27)
	(calibration_target instrument2 GroundStation16)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star2)
	(supports instrument3 thermograph2)
	(calibration_target instrument3 Star6)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Star17)
	(supports instrument4 thermograph3)
	(supports instrument4 thermograph1)
	(calibration_target instrument4 GroundStation28)
	(calibration_target instrument4 GroundStation32)
	(calibration_target instrument4 Star8)
	(calibration_target instrument4 Star26)
	(calibration_target instrument4 GroundStation19)
	(calibration_target instrument4 Star23)
	(calibration_target instrument4 GroundStation16)
	(calibration_target instrument4 Star20)
	(calibration_target instrument4 Star25)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star2)
	(supports instrument5 thermograph1)
	(supports instrument5 thermograph3)
	(calibration_target instrument5 GroundStation33)
	(calibration_target instrument5 GroundStation10)
	(on_board instrument5 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Phenomenon34)
)
(:goal (and
	(pointing satellite4 Phenomenon35)
	(pointing satellite5 Star2)
	(have_image Phenomenon34 thermograph2)
	(have_image Phenomenon35 thermograph3)
	(have_image Planet36 thermograph0)
	(have_image Phenomenon37 thermograph2)
	(have_image Star38 thermograph0)
	(have_image Planet39 thermograph3)
))

)
