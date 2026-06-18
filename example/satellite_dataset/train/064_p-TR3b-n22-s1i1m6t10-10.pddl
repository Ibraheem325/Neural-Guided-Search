(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph4 - mode
	infrared5 - mode
	spectrograph1 - mode
	spectrograph0 - mode
	spectrograph2 - mode
	infrared3 - mode
	GroundStation0 - direction
	Star1 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star6 - direction
	Star7 - direction
	Star8 - direction
	GroundStation9 - direction
	Planet10 - direction
	Phenomenon11 - direction
	Phenomenon12 - direction
	Planet13 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph2)
	(supports instrument0 spectrograph0)
	(supports instrument0 spectrograph1)
	(supports instrument0 infrared5)
	(supports instrument0 thermograph4)
	(calibration_target instrument0 GroundStation9)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation9)
)
(:goal (and
	(pointing satellite0 Phenomenon11)
	(have_image Planet10 infrared5)
	(have_image Phenomenon11 infrared3)
	(have_image Phenomenon11 spectrograph2)
	(have_image Phenomenon12 spectrograph2)
	(have_image Phenomenon12 spectrograph0)
	(have_image Planet13 infrared3)
	(have_image Planet13 spectrograph0)
))

)
