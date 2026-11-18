(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	instrument4 - instrument
	satellite3 - satellite
	instrument5 - instrument
	image0 - mode
	spectrograph4 - mode
	infrared1 - mode
	infrared3 - mode
	image2 - mode
	GroundStation1 - direction
	GroundStation2 - direction
	GroundStation0 - direction
	Star3 - direction
	Planet4 - direction
)
(:init
	(supports instrument0 infrared3)
	(supports instrument0 image2)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation2)
	(supports instrument1 infrared1)
	(supports instrument1 spectrograph4)
	(supports instrument1 image0)
	(calibration_target instrument1 GroundStation1)
	(supports instrument2 infrared1)
	(calibration_target instrument2 GroundStation0)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation2)
	(supports instrument3 image0)
	(supports instrument3 infrared1)
	(supports instrument3 spectrograph4)
	(calibration_target instrument3 GroundStation0)
	(supports instrument4 spectrograph4)
	(supports instrument4 infrared3)
	(calibration_target instrument4 GroundStation2)
	(on_board instrument3 satellite2)
	(on_board instrument4 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation1)
	(supports instrument5 spectrograph4)
	(supports instrument5 infrared3)
	(supports instrument5 infrared1)
	(calibration_target instrument5 GroundStation0)
	(on_board instrument5 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Planet4)
)
(:goal (and
	(pointing satellite0 GroundStation0)
	(pointing satellite1 Planet4)
	(have_image Star3 spectrograph4)
	(have_image Planet4 infrared1)
))

)
