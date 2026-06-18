(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared2 - mode
	image1 - mode
	thermograph3 - mode
	infrared5 - mode
	spectrograph4 - mode
	thermograph0 - mode
	Star1 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star6 - direction
	Star7 - direction
	GroundStation8 - direction
	Star9 - direction
	GroundStation10 - direction
	Star2 - direction
	Star11 - direction
	Star0 - direction
	Planet12 - direction
	Phenomenon13 - direction
	Planet14 - direction
	Phenomenon15 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 spectrograph4)
	(supports instrument0 thermograph3)
	(supports instrument0 thermograph0)
	(supports instrument0 infrared5)
	(supports instrument0 image1)
	(calibration_target instrument0 Star0)
	(calibration_target instrument0 Star11)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star9)
)
(:goal (and
	(have_image Planet12 spectrograph4)
	(have_image Phenomenon13 image1)
	(have_image Planet14 infrared2)
	(have_image Phenomenon15 thermograph3)
	(have_image Phenomenon15 infrared2)
))

)
