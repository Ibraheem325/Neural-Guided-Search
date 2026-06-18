(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	infrared1 - mode
	spectrograph0 - mode
	Star0 - direction
	Star1 - direction
	Star2 - direction
	Star3 - direction
	GroundStation4 - direction
	GroundStation5 - direction
	Star7 - direction
	GroundStation8 - direction
	Star9 - direction
	Star10 - direction
	Star11 - direction
	Star12 - direction
	Star6 - direction
	Phenomenon13 - direction
	Star14 - direction
	Star15 - direction
	Planet16 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(supports instrument0 infrared1)
	(calibration_target instrument0 Star6)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star10)
)
(:goal (and
	(pointing satellite0 Star12)
	(have_image Phenomenon13 spectrograph0)
	(have_image Star14 infrared1)
	(have_image Star15 infrared1)
	(have_image Planet16 infrared1)
))

)
