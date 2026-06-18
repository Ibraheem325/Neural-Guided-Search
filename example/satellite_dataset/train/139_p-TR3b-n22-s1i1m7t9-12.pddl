(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared2 - mode
	image1 - mode
	thermograph0 - mode
	infrared5 - mode
	thermograph3 - mode
	image6 - mode
	spectrograph4 - mode
	GroundStation0 - direction
	Star1 - direction
	Star2 - direction
	Star3 - direction
	GroundStation4 - direction
	Star8 - direction
	Star7 - direction
	Star5 - direction
	GroundStation6 - direction
	Star9 - direction
	Star10 - direction
	Planet11 - direction
	Planet12 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 image6)
	(supports instrument0 spectrograph4)
	(supports instrument0 thermograph3)
	(supports instrument0 infrared5)
	(supports instrument0 thermograph0)
	(supports instrument0 image1)
	(calibration_target instrument0 GroundStation6)
	(calibration_target instrument0 Star5)
	(calibration_target instrument0 Star7)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star2)
)
(:goal (and
	(pointing satellite0 GroundStation6)
	(have_image Star9 spectrograph4)
	(have_image Star10 thermograph3)
	(have_image Planet11 thermograph0)
	(have_image Planet12 thermograph0)
))

)
