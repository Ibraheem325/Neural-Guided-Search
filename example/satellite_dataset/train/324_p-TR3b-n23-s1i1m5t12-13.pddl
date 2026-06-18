(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared3 - mode
	thermograph2 - mode
	spectrograph0 - mode
	image1 - mode
	spectrograph4 - mode
	Star0 - direction
	GroundStation1 - direction
	Star3 - direction
	Star4 - direction
	Star5 - direction
	Star6 - direction
	GroundStation7 - direction
	GroundStation8 - direction
	Star9 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	Star2 - direction
	Star12 - direction
	Star13 - direction
	Star14 - direction
	Planet15 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 spectrograph4)
	(supports instrument0 spectrograph0)
	(supports instrument0 thermograph2)
	(supports instrument0 infrared3)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star13)
)
(:goal (and
	(pointing satellite0 GroundStation1)
	(have_image Star12 thermograph2)
	(have_image Star13 image1)
	(have_image Star14 spectrograph4)
	(have_image Planet15 image1)
))

)
