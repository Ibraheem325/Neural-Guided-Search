(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	image0 - mode
	image1 - mode
	spectrograph2 - mode
	image3 - mode
	Star0 - direction
	Star2 - direction
	Star1 - direction
	Star3 - direction
	Star4 - direction
	Phenomenon5 - direction
	Star6 - direction
	Planet7 - direction
	Planet8 - direction
	Phenomenon9 - direction
	Planet10 - direction
	Phenomenon11 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star3)
	(supports instrument1 image3)
	(supports instrument1 image1)
	(supports instrument1 image0)
	(calibration_target instrument1 Star3)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet10)
)
(:goal (and
	(pointing satellite1 Star1)
	(have_image Star4 image0)
	(have_image Phenomenon5 image0)
	(have_image Star6 image0)
	(have_image Planet7 image1)
	(have_image Planet8 image0)
	(have_image Phenomenon9 spectrograph2)
	(have_image Planet10 image3)
	(have_image Phenomenon11 image0)
))

)
