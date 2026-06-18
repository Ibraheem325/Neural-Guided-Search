(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	spectrograph6 - mode
	infrared3 - mode
	infrared5 - mode
	spectrograph2 - mode
	spectrograph1 - mode
	thermograph4 - mode
	Star1 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star6 - direction
	Star7 - direction
	GroundStation8 - direction
	Star0 - direction
	Phenomenon9 - direction
	Planet10 - direction
	Star11 - direction
	Phenomenon12 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(supports instrument0 thermograph4)
	(supports instrument0 spectrograph1)
	(supports instrument0 infrared5)
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph6)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
)
(:goal (and
	(have_image Phenomenon9 spectrograph1)
	(have_image Planet10 spectrograph0)
	(have_image Star11 infrared3)
	(have_image Star11 infrared5)
	(have_image Phenomenon12 thermograph4)
	(have_image Phenomenon12 spectrograph1)
))

)
