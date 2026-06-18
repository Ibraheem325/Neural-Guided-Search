(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	thermograph2 - mode
	spectrograph0 - mode
	image1 - mode
	Star0 - direction
	Star2 - direction
	Star5 - direction
	Star6 - direction
	Star7 - direction
	Star9 - direction
	Star10 - direction
	GroundStation11 - direction
	Star3 - direction
	Star1 - direction
	Star8 - direction
	Star4 - direction
	Star12 - direction
	Planet13 - direction
	Star14 - direction
	Star15 - direction
)
(:init
	(supports instrument0 thermograph2)
	(supports instrument0 spectrograph0)
	(supports instrument0 image1)
	(calibration_target instrument0 Star4)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 Star3)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
)
(:goal (and
	(have_image Star12 spectrograph0)
	(have_image Planet13 spectrograph0)
	(have_image Star14 spectrograph0)
	(have_image Star15 thermograph2)
))

)
