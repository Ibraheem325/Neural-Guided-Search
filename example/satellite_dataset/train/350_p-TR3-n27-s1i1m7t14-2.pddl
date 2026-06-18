(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image5 - mode
	spectrograph0 - mode
	spectrograph6 - mode
	image4 - mode
	thermograph1 - mode
	infrared2 - mode
	infrared3 - mode
	Star0 - direction
	GroundStation1 - direction
	Star2 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star7 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	Star11 - direction
	GroundStation13 - direction
	GroundStation12 - direction
	GroundStation6 - direction
	Phenomenon14 - direction
	Phenomenon15 - direction
	Phenomenon16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 infrared3)
	(supports instrument0 thermograph1)
	(supports instrument0 image4)
	(supports instrument0 spectrograph6)
	(supports instrument0 spectrograph0)
	(supports instrument0 image5)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 GroundStation12)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation13)
)
(:goal (and
	(have_image Phenomenon14 image5)
	(have_image Phenomenon14 image4)
	(have_image Phenomenon15 spectrograph0)
	(have_image Phenomenon15 infrared3)
	(have_image Phenomenon16 spectrograph0)
	(have_image Phenomenon16 infrared2)
	(have_image Planet17 spectrograph0)
))

)
