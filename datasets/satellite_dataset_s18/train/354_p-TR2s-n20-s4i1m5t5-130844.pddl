(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	satellite3 - satellite
	instrument3 - instrument
	spectrograph2 - mode
	image0 - mode
	image1 - mode
	infrared3 - mode
	spectrograph4 - mode
	GroundStation2 - direction
	GroundStation3 - direction
	GroundStation1 - direction
	GroundStation4 - direction
	GroundStation0 - direction
	Star5 - direction
	Planet6 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
	(supports instrument1 infrared3)
	(supports instrument1 spectrograph4)
	(supports instrument1 spectrograph2)
	(calibration_target instrument1 GroundStation4)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet6)
	(supports instrument2 image0)
	(supports instrument2 spectrograph4)
	(supports instrument2 spectrograph2)
	(calibration_target instrument2 GroundStation4)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation2)
	(supports instrument3 infrared3)
	(supports instrument3 spectrograph4)
	(supports instrument3 image0)
	(supports instrument3 image1)
	(calibration_target instrument3 GroundStation0)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 GroundStation0)
)
(:goal (and
	(have_image Star5 image1)
	(have_image Planet6 image1)
))

)
