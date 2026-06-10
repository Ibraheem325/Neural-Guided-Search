(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	satellite1 - satellite
	instrument2 - instrument
	infrared3 - mode
	spectrograph1 - mode
	spectrograph2 - mode
	spectrograph0 - mode
	GroundStation3 - direction
	Star5 - direction
	GroundStation6 - direction
	Star8 - direction
	Star11 - direction
	Star12 - direction
	GroundStation14 - direction
	GroundStation17 - direction
	Star19 - direction
	GroundStation15 - direction
	GroundStation16 - direction
	GroundStation7 - direction
	GroundStation13 - direction
	Star10 - direction
	GroundStation0 - direction
	Star1 - direction
	GroundStation2 - direction
	Star9 - direction
	Star4 - direction
	GroundStation18 - direction
	Phenomenon20 - direction
	Planet21 - direction
	Phenomenon22 - direction
	Phenomenon23 - direction
	Phenomenon24 - direction
	Planet25 - direction
	Star26 - direction
	Phenomenon27 - direction
	Star28 - direction
	Phenomenon29 - direction
	Star30 - direction
	Star31 - direction
)
(:init
	(supports instrument0 spectrograph2)
	(supports instrument0 spectrograph0)
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 Star1)
	(calibration_target instrument0 GroundStation15)
	(calibration_target instrument0 Star4)
	(supports instrument1 spectrograph0)
	(supports instrument1 infrared3)
	(supports instrument1 spectrograph1)
	(calibration_target instrument1 Star10)
	(calibration_target instrument1 GroundStation13)
	(calibration_target instrument1 Star1)
	(calibration_target instrument1 GroundStation7)
	(calibration_target instrument1 GroundStation16)
	(calibration_target instrument1 Star9)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation17)
	(supports instrument2 spectrograph2)
	(supports instrument2 spectrograph1)
	(supports instrument2 spectrograph0)
	(calibration_target instrument2 GroundStation18)
	(calibration_target instrument2 Star4)
	(calibration_target instrument2 Star9)
	(calibration_target instrument2 GroundStation2)
	(calibration_target instrument2 Star1)
	(calibration_target instrument2 GroundStation0)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star8)
)
(:goal (and
	(pointing satellite0 GroundStation0)
	(pointing satellite1 GroundStation6)
	(have_image Phenomenon20 spectrograph1)
	(have_image Planet21 spectrograph0)
	(have_image Phenomenon22 spectrograph0)
	(have_image Phenomenon23 spectrograph0)
	(have_image Phenomenon24 infrared3)
	(have_image Planet25 spectrograph2)
	(have_image Star26 spectrograph0)
	(have_image Phenomenon27 spectrograph1)
	(have_image Star28 spectrograph0)
	(have_image Phenomenon29 spectrograph1)
	(have_image Star30 infrared3)
	(have_image Star31 infrared3)
))

)
