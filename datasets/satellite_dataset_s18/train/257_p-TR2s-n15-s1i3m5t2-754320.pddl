(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	image1 - mode
	image2 - mode
	image0 - mode
	thermograph3 - mode
	spectrograph4 - mode
	GroundStation1 - direction
	GroundStation0 - direction
	Star2 - direction
	Star3 - direction
	Phenomenon4 - direction
	Star5 - direction
)
(:init
	(supports instrument0 image2)
	(supports instrument0 image0)
	(calibration_target instrument0 GroundStation1)
	(supports instrument1 image2)
	(supports instrument1 spectrograph4)
	(calibration_target instrument1 GroundStation1)
	(supports instrument2 image1)
	(supports instrument2 thermograph3)
	(calibration_target instrument2 GroundStation0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star2)
)
(:goal (and
	(have_image Star2 spectrograph4)
	(have_image Star3 thermograph3)
	(have_image Phenomenon4 thermograph3)
	(have_image Star5 image1)
))

)
