(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	spectrograph0 - mode
	Star1 - direction
	GroundStation2 - direction
	Star6 - direction
	GroundStation9 - direction
	Star10 - direction
	Star11 - direction
	Star14 - direction
	Star15 - direction
	GroundStation16 - direction
	GroundStation17 - direction
	GroundStation19 - direction
	GroundStation20 - direction
	Star21 - direction
	Star22 - direction
	Star23 - direction
	Star25 - direction
	Star26 - direction
	GroundStation28 - direction
	Star7 - direction
	Star3 - direction
	Star27 - direction
	GroundStation13 - direction
	Star5 - direction
	Star18 - direction
	GroundStation12 - direction
	Star0 - direction
	GroundStation8 - direction
	GroundStation24 - direction
	GroundStation4 - direction
	Star29 - direction
	Phenomenon30 - direction
	Phenomenon31 - direction
	Planet32 - direction
	Phenomenon33 - direction
	Phenomenon34 - direction
	Phenomenon35 - direction
)
(:init
	(supports instrument0 spectrograph0)
	(calibration_target instrument0 Star3)
	(calibration_target instrument0 Star7)
	(calibration_target instrument0 GroundStation8)
	(calibration_target instrument0 GroundStation24)
	(calibration_target instrument0 GroundStation4)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star1)
	(supports instrument1 spectrograph0)
	(calibration_target instrument1 GroundStation8)
	(calibration_target instrument1 Star0)
	(calibration_target instrument1 GroundStation24)
	(calibration_target instrument1 GroundStation12)
	(calibration_target instrument1 Star18)
	(calibration_target instrument1 Star5)
	(calibration_target instrument1 GroundStation13)
	(calibration_target instrument1 Star27)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star10)
	(supports instrument2 spectrograph0)
	(calibration_target instrument2 GroundStation4)
	(calibration_target instrument2 GroundStation24)
	(calibration_target instrument2 GroundStation8)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star6)
)
(:goal (and
	(pointing satellite0 Star14)
	(pointing satellite1 Planet32)
	(have_image Star29 spectrograph0)
	(have_image Phenomenon30 spectrograph0)
	(have_image Phenomenon31 spectrograph0)
	(have_image Planet32 spectrograph0)
	(have_image Phenomenon33 spectrograph0)
	(have_image Phenomenon34 spectrograph0)
	(have_image Phenomenon35 spectrograph0)
))

)
