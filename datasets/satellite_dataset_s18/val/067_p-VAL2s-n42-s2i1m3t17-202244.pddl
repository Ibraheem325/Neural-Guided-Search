(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	spectrograph2 - mode
	spectrograph0 - mode
	spectrograph1 - mode
	Star0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star3 - direction
	GroundStation6 - direction
	Star8 - direction
	Star9 - direction
	GroundStation10 - direction
	Star11 - direction
	GroundStation12 - direction
	Star14 - direction
	Star16 - direction
	GroundStation4 - direction
	Star7 - direction
	GroundStation15 - direction
	GroundStation5 - direction
	Star13 - direction
	Planet17 - direction
	Planet18 - direction
	Phenomenon19 - direction
	Star20 - direction
	Planet21 - direction
	Phenomenon22 - direction
	Star23 - direction
	Star24 - direction
	Star25 - direction
	Phenomenon26 - direction
	Planet27 - direction
	Star28 - direction
	Planet29 - direction
	Star30 - direction
	Star31 - direction
	Phenomenon32 - direction
	Star33 - direction
	Star34 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(supports instrument0 spectrograph0)
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 GroundStation4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star3)
	(supports instrument1 spectrograph2)
	(supports instrument1 spectrograph1)
	(calibration_target instrument1 Star13)
	(calibration_target instrument1 GroundStation5)
	(calibration_target instrument1 GroundStation15)
	(calibration_target instrument1 Star7)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star0)
)
(:goal (and
	(pointing satellite1 Star3)
	(have_image Planet17 spectrograph2)
	(have_image Planet18 spectrograph2)
	(have_image Phenomenon19 spectrograph0)
	(have_image Star20 spectrograph1)
	(have_image Planet21 spectrograph1)
	(have_image Phenomenon22 spectrograph1)
	(have_image Star23 spectrograph1)
	(have_image Star24 spectrograph2)
	(have_image Star25 spectrograph2)
	(have_image Phenomenon26 spectrograph2)
	(have_image Planet27 spectrograph1)
	(have_image Star28 spectrograph2)
	(have_image Planet29 spectrograph2)
	(have_image Star30 spectrograph0)
	(have_image Star31 spectrograph1)
	(have_image Phenomenon32 spectrograph0)
	(have_image Star33 spectrograph1)
	(have_image Star34 spectrograph2)
))

)
