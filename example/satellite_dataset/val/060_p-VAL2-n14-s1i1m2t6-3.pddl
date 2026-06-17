(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	infrared1 - mode
	Star0 - direction
	Star1 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	Star2 - direction
	Star3 - direction
	Star6 - direction
	Planet7 - direction
	Star8 - direction
	Planet9 - direction
)
(:init
	(supports instrument0 infrared1)
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star3)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star8)
)
(:goal (and
	(pointing satellite0 Star6)
	(have_image Star6 spectrograph0)
	(have_image Planet7 infrared1)
	(have_image Star8 spectrograph0)
	(have_image Planet9 infrared1)
))

)
