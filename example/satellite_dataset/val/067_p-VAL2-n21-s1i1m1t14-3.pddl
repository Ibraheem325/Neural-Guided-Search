(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	spectrograph0 - mode
	Star1 - direction
	Star2 - direction
	Star3 - direction
	GroundStation4 - direction
	Star5 - direction
	Star6 - direction
	Star7 - direction
	Star8 - direction
	GroundStation9 - direction
	GroundStation11 - direction
	GroundStation12 - direction
	Star13 - direction
	Star0 - direction
	Star10 - direction
	Planet14 - direction
	Planet15 - direction
	Phenomenon16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star10)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon16)
)
(:goal (and
	(have_image Planet14 spectrograph0)
	(have_image Planet15 spectrograph0)
	(have_image Phenomenon16 spectrograph0)
	(have_image Star17 spectrograph0)
))

)
