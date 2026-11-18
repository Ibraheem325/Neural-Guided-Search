(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	image1 - mode
	Star0 - direction
	GroundStation3 - direction
	GroundStation4 - direction
	GroundStation6 - direction
	Star7 - direction
	Star8 - direction
	GroundStation10 - direction
	GroundStation11 - direction
	GroundStation1 - direction
	Star2 - direction
	GroundStation9 - direction
	GroundStation5 - direction
	Phenomenon12 - direction
	Star13 - direction
	Planet14 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 image1)
	(calibration_target instrument0 GroundStation5)
	(calibration_target instrument0 GroundStation9)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star2)
)
(:goal (and
	(have_image Phenomenon12 spectrograph0)
	(have_image Star13 spectrograph0)
	(have_image Planet14 image1)
))

)
