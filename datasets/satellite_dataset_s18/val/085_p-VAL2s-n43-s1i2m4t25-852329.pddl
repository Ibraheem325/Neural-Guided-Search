(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared2 - mode
	thermograph0 - mode
	thermograph1 - mode
	image3 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	GroundStation3 - direction
	Star4 - direction
	Star5 - direction
	Star6 - direction
	Star7 - direction
	Star8 - direction
	Star11 - direction
	Star12 - direction
	GroundStation13 - direction
	Star14 - direction
	GroundStation15 - direction
	GroundStation16 - direction
	Star18 - direction
	GroundStation19 - direction
	Star21 - direction
	GroundStation22 - direction
	Star23 - direction
	GroundStation24 - direction
	GroundStation20 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	Star17 - direction
	GroundStation2 - direction
	Star25 - direction
	Star26 - direction
	Star27 - direction
	Planet28 - direction
	Planet29 - direction
	Phenomenon30 - direction
	Star31 - direction
	Star32 - direction
	Phenomenon33 - direction
	Star34 - direction
	Phenomenon35 - direction
	Star36 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 image3)
	(supports instrument0 thermograph1)
	(supports instrument0 infrared2)
	(calibration_target instrument0 GroundStation2)
	(calibration_target instrument0 Star17)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 GroundStation20)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star17)
)
(:goal (and
	(have_image Star25 image3)
	(have_image Star26 image3)
	(have_image Star27 image3)
	(have_image Planet28 thermograph0)
	(have_image Planet29 thermograph1)
	(have_image Phenomenon30 thermograph1)
	(have_image Star31 image3)
	(have_image Star32 thermograph0)
	(have_image Phenomenon33 thermograph1)
	(have_image Star34 thermograph1)
	(have_image Phenomenon35 image3)
	(have_image Star36 infrared2)
))

)
