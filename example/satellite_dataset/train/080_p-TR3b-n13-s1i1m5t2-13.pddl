(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	image1 - mode
	spectrograph0 - mode
	spectrograph4 - mode
	thermograph2 - mode
	infrared3 - mode
	GroundStation1 - direction
	Star0 - direction
	Star2 - direction
	Phenomenon3 - direction
	Star4 - direction
	Star5 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 spectrograph4)
	(supports instrument0 thermograph2)
	(supports instrument0 infrared3)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation1)
)
(:goal (and
	(pointing satellite0 Phenomenon3)
	(have_image Star2 spectrograph4)
	(have_image Phenomenon3 thermograph2)
	(have_image Star4 thermograph2)
	(have_image Star5 spectrograph4)
))

)
