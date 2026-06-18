(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	infrared1 - mode
	Star0 - direction
	Star2 - direction
	Star3 - direction
	GroundStation5 - direction
	Star6 - direction
	Star7 - direction
	Star9 - direction
	Star10 - direction
	Star11 - direction
	Star12 - direction
	Star13 - direction
	GroundStation4 - direction
	GroundStation8 - direction
	Star1 - direction
	Star14 - direction
	Star15 - direction
	Star16 - direction
	Planet17 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 infrared1)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 GroundStation8)
	(calibration_target instrument0 GroundStation4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation4)
)
(:goal (and
	(pointing satellite0 Star12)
	(have_image Star14 spectrograph0)
	(have_image Star15 infrared1)
	(have_image Star16 spectrograph0)
	(have_image Planet17 infrared1)
))

)
