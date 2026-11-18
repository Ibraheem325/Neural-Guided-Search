(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image4 - mode
	spectrograph0 - mode
	image5 - mode
	infrared2 - mode
	infrared3 - mode
	thermograph1 - mode
	GroundStation0 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	GroundStation4 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	GroundStation9 - direction
	GroundStation11 - direction
	Star12 - direction
	GroundStation8 - direction
	GroundStation10 - direction
	GroundStation3 - direction
	Star5 - direction
	Planet13 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Phenomenon16 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 thermograph1)
	(supports instrument0 infrared3)
	(supports instrument0 image5)
	(supports instrument0 spectrograph0)
	(supports instrument0 image4)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 GroundStation3)
	(calibration_target instrument0 GroundStation10)
	(calibration_target instrument0 GroundStation8)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
)
(:goal (and
	(have_image Planet13 thermograph1)
	(have_image Planet13 image5)
	(have_image Phenomenon14 image5)
	(have_image Phenomenon14 infrared2)
	(have_image Phenomenon15 image5)
	(have_image Phenomenon15 spectrograph0)
	(have_image Phenomenon16 image5)
	(have_image Phenomenon16 infrared2)
))

)
