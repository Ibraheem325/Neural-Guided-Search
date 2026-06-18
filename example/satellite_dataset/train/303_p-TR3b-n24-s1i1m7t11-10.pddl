(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph2 - mode
	thermograph4 - mode
	infrared3 - mode
	spectrograph1 - mode
	spectrograph0 - mode
	infrared5 - mode
	spectrograph6 - mode
	Star0 - direction
	Star1 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star6 - direction
	GroundStation8 - direction
	Star9 - direction
	Star10 - direction
	Star7 - direction
	Planet11 - direction
	Star12 - direction
	Phenomenon13 - direction
	Planet14 - direction
)
(:init
	(supports instrument0 thermograph4)
	(supports instrument0 spectrograph2)
	(supports instrument0 spectrograph0)
	(supports instrument0 spectrograph6)
	(supports instrument0 infrared5)
	(supports instrument0 spectrograph1)
	(supports instrument0 infrared3)
	(calibration_target instrument0 Star7)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon13)
)
(:goal (and
	(pointing satellite0 Star1)
	(have_image Planet11 spectrograph6)
	(have_image Star12 spectrograph1)
	(have_image Phenomenon13 spectrograph0)
	(have_image Planet14 infrared5)
	(have_image Planet14 spectrograph6)
))

)
