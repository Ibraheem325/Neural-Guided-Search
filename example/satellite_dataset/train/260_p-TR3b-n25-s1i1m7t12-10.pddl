(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph1 - mode
	thermograph4 - mode
	infrared5 - mode
	spectrograph2 - mode
	spectrograph6 - mode
	infrared3 - mode
	spectrograph0 - mode
	Star0 - direction
	Star1 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star6 - direction
	Star7 - direction
	Star10 - direction
	GroundStation11 - direction
	Star9 - direction
	GroundStation8 - direction
	Planet12 - direction
	Phenomenon13 - direction
	Planet14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(supports instrument0 spectrograph1)
	(supports instrument0 infrared5)
	(supports instrument0 spectrograph0)
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph6)
	(supports instrument0 thermograph4)
	(calibration_target instrument0 GroundStation8)
	(calibration_target instrument0 Star9)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation11)
)
(:goal (and
	(have_image Planet12 infrared3)
	(have_image Phenomenon13 spectrograph6)
	(have_image Planet14 spectrograph6)
	(have_image Planet14 spectrograph0)
	(have_image Planet15 spectrograph6)
))

)
