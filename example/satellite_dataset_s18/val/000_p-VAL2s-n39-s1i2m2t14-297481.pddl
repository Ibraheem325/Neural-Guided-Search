(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared0 - mode
	spectrograph1 - mode
	Star0 - direction
	Star2 - direction
	Star3 - direction
	Star4 - direction
	Star5 - direction
	GroundStation6 - direction
	Star7 - direction
	GroundStation8 - direction
	GroundStation9 - direction
	Star10 - direction
	GroundStation11 - direction
	GroundStation12 - direction
	Star13 - direction
	Star1 - direction
	Star14 - direction
	Planet15 - direction
	Planet16 - direction
	Planet17 - direction
	Planet18 - direction
	Star19 - direction
	Star20 - direction
	Planet21 - direction
	Star22 - direction
	Phenomenon23 - direction
	Star24 - direction
	Phenomenon25 - direction
	Star26 - direction
	Planet27 - direction
	Planet28 - direction
	Phenomenon29 - direction
	Planet30 - direction
	Star31 - direction
	Phenomenon32 - direction
	Phenomenon33 - direction
	Star34 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(supports instrument0 infrared0)
	(calibration_target instrument0 Star1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon32)
)
(:goal (and
	(have_image Star14 spectrograph1)
	(have_image Planet15 spectrograph1)
	(have_image Planet16 infrared0)
	(have_image Planet17 spectrograph1)
	(have_image Planet18 infrared0)
	(have_image Star19 spectrograph1)
	(have_image Star20 infrared0)
	(have_image Planet21 infrared0)
	(have_image Star22 spectrograph1)
	(have_image Phenomenon23 infrared0)
	(have_image Star24 spectrograph1)
	(have_image Phenomenon25 infrared0)
	(have_image Star26 infrared0)
	(have_image Planet27 spectrograph1)
	(have_image Planet28 spectrograph1)
	(have_image Phenomenon29 spectrograph1)
	(have_image Planet30 infrared0)
	(have_image Star31 spectrograph1)
	(have_image Phenomenon32 spectrograph1)
	(have_image Phenomenon33 spectrograph1)
	(have_image Star34 spectrograph1)
))

)
