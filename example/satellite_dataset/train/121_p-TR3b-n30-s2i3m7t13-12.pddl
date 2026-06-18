(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	thermograph3 - mode
	image1 - mode
	infrared5 - mode
	image6 - mode
	infrared2 - mode
	thermograph0 - mode
	spectrograph4 - mode
	GroundStation0 - direction
	Star2 - direction
	GroundStation4 - direction
	GroundStation6 - direction
	Star8 - direction
	Star7 - direction
	Star1 - direction
	Star12 - direction
	Star11 - direction
	Star9 - direction
	Star10 - direction
	Star3 - direction
	Star5 - direction
	Planet13 - direction
	Star14 - direction
	Star15 - direction
	Planet16 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 thermograph0)
	(supports instrument0 infrared5)
	(supports instrument0 infrared2)
	(supports instrument0 thermograph3)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 Star9)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star12)
	(supports instrument1 image6)
	(calibration_target instrument1 Star9)
	(calibration_target instrument1 Star11)
	(calibration_target instrument1 Star12)
	(supports instrument2 infrared5)
	(supports instrument2 spectrograph4)
	(calibration_target instrument2 Star5)
	(calibration_target instrument2 Star3)
	(calibration_target instrument2 Star10)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet13)
)
(:goal (and
	(pointing satellite1 Star12)
	(have_image Planet13 image6)
	(have_image Star14 image6)
	(have_image Star15 image1)
	(have_image Planet16 infrared5)
))

)
