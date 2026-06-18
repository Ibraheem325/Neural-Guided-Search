(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph4 - mode
	spectrograph0 - mode
	image1 - mode
	infrared3 - mode
	thermograph2 - mode
	image5 - mode
	Star0 - direction
	GroundStation1 - direction
	GroundStation2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star9 - direction
	Star10 - direction
	Star11 - direction
	GroundStation6 - direction
	Star7 - direction
	Star8 - direction
	Phenomenon12 - direction
	Phenomenon13 - direction
	Phenomenon14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph4)
	(supports instrument0 thermograph2)
	(supports instrument0 image5)
	(supports instrument0 image1)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 GroundStation6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon12)
)
(:goal (and
	(have_image Phenomenon12 spectrograph0)
	(have_image Phenomenon13 image5)
	(have_image Phenomenon13 spectrograph4)
	(have_image Phenomenon14 infrared3)
	(have_image Phenomenon14 spectrograph4)
	(have_image Planet15 infrared3)
	(have_image Planet15 spectrograph0)
))

)
