(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	infrared3 - mode
	image1 - mode
	thermograph2 - mode
	image5 - mode
	spectrograph0 - mode
	spectrograph4 - mode
	Star0 - direction
	GroundStation1 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	Star5 - direction
	GroundStation6 - direction
	Star7 - direction
	Star8 - direction
	Star9 - direction
	Star10 - direction
	GroundStation13 - direction
	Star12 - direction
	Star11 - direction
	GroundStation2 - direction
	Planet14 - direction
	Phenomenon15 - direction
	Planet16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 image1)
	(supports instrument0 image5)
	(calibration_target instrument0 Star12)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet14)
	(supports instrument1 spectrograph0)
	(supports instrument1 image1)
	(supports instrument1 spectrograph4)
	(supports instrument1 thermograph2)
	(supports instrument1 infrared3)
	(calibration_target instrument1 GroundStation2)
	(calibration_target instrument1 Star11)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star17)
)
(:goal (and
	(pointing satellite1 Star5)
	(have_image Planet14 image5)
	(have_image Phenomenon15 spectrograph4)
	(have_image Phenomenon15 spectrograph0)
	(have_image Planet16 image5)
	(have_image Star17 image1)
	(have_image Star17 infrared3)
))

)
