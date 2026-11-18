(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	thermograph1 - mode
	thermograph3 - mode
	infrared2 - mode
	thermograph0 - mode
	thermograph4 - mode
	Star0 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star5 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	GroundStation9 - direction
	Star10 - direction
	GroundStation2 - direction
	Star8 - direction
	Star1 - direction
	Planet11 - direction
	Star12 - direction
	Planet13 - direction
	Star14 - direction
	Star15 - direction
	Phenomenon16 - direction
	Phenomenon17 - direction
	Phenomenon18 - direction
	Planet19 - direction
	Phenomenon20 - direction
	Phenomenon21 - direction
	Planet22 - direction
	Planet23 - direction
)
(:init
	(supports instrument0 thermograph3)
	(supports instrument0 thermograph0)
	(supports instrument0 infrared2)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 GroundStation2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation6)
	(supports instrument1 thermograph0)
	(supports instrument1 thermograph4)
	(calibration_target instrument1 Star1)
	(calibration_target instrument1 Star8)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star10)
)
(:goal (and
	(have_image Planet11 thermograph4)
	(have_image Star12 thermograph4)
	(have_image Planet13 thermograph4)
	(have_image Star14 thermograph3)
	(have_image Star15 thermograph1)
	(have_image Phenomenon16 thermograph1)
	(have_image Phenomenon17 thermograph3)
	(have_image Phenomenon18 thermograph4)
	(have_image Planet19 thermograph0)
	(have_image Phenomenon20 thermograph1)
	(have_image Phenomenon21 thermograph3)
	(have_image Planet22 thermograph0)
	(have_image Planet23 thermograph3)
))

)
