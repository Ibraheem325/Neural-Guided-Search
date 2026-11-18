(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	image0 - mode
	spectrograph1 - mode
	GroundStation0 - direction
	Star1 - direction
	Star2 - direction
	Star4 - direction
	GroundStation6 - direction
	GroundStation7 - direction
	GroundStation9 - direction
	Star3 - direction
	GroundStation5 - direction
	GroundStation8 - direction
	Phenomenon10 - direction
	Star11 - direction
	Planet12 - direction
)
(:init
	(supports instrument0 image0)
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 Star3)
	(calibration_target instrument0 GroundStation9)
	(supports instrument1 spectrograph1)
	(calibration_target instrument1 GroundStation8)
	(calibration_target instrument1 GroundStation5)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation8)
)
(:goal (and
	(pointing satellite0 GroundStation8)
	(have_image Phenomenon10 spectrograph1)
	(have_image Star11 spectrograph1)
	(have_image Planet12 image0)
))

)
