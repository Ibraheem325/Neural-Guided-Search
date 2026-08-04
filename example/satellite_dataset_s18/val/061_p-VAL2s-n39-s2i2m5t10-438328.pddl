(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	instrument3 - instrument
	infrared2 - mode
	infrared1 - mode
	thermograph0 - mode
	thermograph4 - mode
	thermograph3 - mode
	Star0 - direction
	Star5 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	Star9 - direction
	GroundStation2 - direction
	GroundStation1 - direction
	Star3 - direction
	GroundStation6 - direction
	GroundStation4 - direction
	Phenomenon10 - direction
	Planet11 - direction
	Star12 - direction
	Star13 - direction
	Star14 - direction
	Phenomenon15 - direction
	Star16 - direction
	Phenomenon17 - direction
	Planet18 - direction
	Phenomenon19 - direction
	Star20 - direction
	Star21 - direction
	Phenomenon22 - direction
	Planet23 - direction
	Phenomenon24 - direction
	Star25 - direction
	Planet26 - direction
	Star27 - direction
)
(:init
	(supports instrument0 infrared2)
	(calibration_target instrument0 GroundStation2)
	(supports instrument1 thermograph0)
	(supports instrument1 infrared2)
	(supports instrument1 thermograph3)
	(calibration_target instrument1 GroundStation2)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet11)
	(supports instrument2 thermograph4)
	(supports instrument2 infrared1)
	(supports instrument2 infrared2)
	(calibration_target instrument2 GroundStation1)
	(supports instrument3 infrared1)
	(calibration_target instrument3 GroundStation4)
	(calibration_target instrument3 GroundStation6)
	(calibration_target instrument3 Star3)
	(on_board instrument2 satellite1)
	(on_board instrument3 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon24)
)
(:goal (and
	(pointing satellite0 Star20)
	(pointing satellite1 Star27)
	(have_image Phenomenon10 infrared2)
	(have_image Planet11 thermograph4)
	(have_image Star12 thermograph0)
	(have_image Star13 infrared1)
	(have_image Star14 thermograph4)
	(have_image Phenomenon15 infrared2)
	(have_image Star16 thermograph4)
	(have_image Phenomenon17 thermograph4)
	(have_image Planet18 thermograph4)
	(have_image Phenomenon19 infrared2)
	(have_image Star20 thermograph4)
	(have_image Star21 infrared1)
	(have_image Phenomenon22 thermograph0)
	(have_image Planet23 thermograph0)
	(have_image Phenomenon24 infrared1)
	(have_image Star25 thermograph3)
	(have_image Planet26 thermograph3)
	(have_image Star27 thermograph0)
))

)
