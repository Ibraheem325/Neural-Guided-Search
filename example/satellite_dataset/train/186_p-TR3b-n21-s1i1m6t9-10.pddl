(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared5 - mode
	thermograph4 - mode
	spectrograph1 - mode
	infrared3 - mode
	spectrograph0 - mode
	spectrograph2 - mode
	Star1 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star6 - direction
	Star7 - direction
	Star8 - direction
	GroundStation0 - direction
	Planet9 - direction
	Planet10 - direction
	Phenomenon11 - direction
	Phenomenon12 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph1)
	(supports instrument0 thermograph4)
	(supports instrument0 spectrograph2)
	(supports instrument0 spectrograph0)
	(supports instrument0 infrared5)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star5)
)
(:goal (and
	(have_image Planet9 spectrograph1)
	(have_image Planet10 spectrograph1)
	(have_image Planet10 spectrograph0)
	(have_image Phenomenon11 infrared3)
	(have_image Phenomenon11 spectrograph0)
	(have_image Phenomenon12 infrared5)
	(have_image Phenomenon12 spectrograph1)
))

)
