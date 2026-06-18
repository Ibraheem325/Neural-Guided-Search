(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared5 - mode
	image6 - mode
	spectrograph4 - mode
	infrared2 - mode
	image1 - mode
	thermograph0 - mode
	thermograph3 - mode
	GroundStation0 - direction
	Star1 - direction
	Star2 - direction
	GroundStation4 - direction
	GroundStation6 - direction
	Star7 - direction
	Star8 - direction
	Star9 - direction
	Star10 - direction
	Star3 - direction
	Star5 - direction
	Phenomenon11 - direction
	Planet12 - direction
	Planet13 - direction
	Star14 - direction
)
(:init
	(supports instrument0 thermograph0)
	(supports instrument0 thermograph3)
	(supports instrument0 infrared5)
	(supports instrument0 image1)
	(supports instrument0 infrared2)
	(supports instrument0 spectrograph4)
	(supports instrument0 image6)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 Star3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
)
(:goal (and
	(have_image Phenomenon11 image6)
	(have_image Phenomenon11 infrared5)
	(have_image Planet12 thermograph3)
	(have_image Planet12 infrared2)
	(have_image Planet13 image6)
	(have_image Planet13 thermograph3)
	(have_image Star14 image1)
	(have_image Star14 infrared2)
))

)
