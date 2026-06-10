(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	infrared0 - mode
	infrared2 - mode
	spectrograph1 - mode
	image3 - mode
	GroundStation0 - direction
	GroundStation4 - direction
	Star5 - direction
	GroundStation9 - direction
	GroundStation10 - direction
	Star12 - direction
	Star13 - direction
	Star14 - direction
	GroundStation15 - direction
	GroundStation16 - direction
	Star17 - direction
	Star19 - direction
	GroundStation11 - direction
	GroundStation7 - direction
	Star2 - direction
	Star8 - direction
	GroundStation1 - direction
	Star6 - direction
	GroundStation18 - direction
	GroundStation3 - direction
	Star20 - direction
	Star21 - direction
	Star22 - direction
	Planet23 - direction
	Planet24 - direction
	Planet25 - direction
	Phenomenon26 - direction
	Star27 - direction
	Planet28 - direction
	Planet29 - direction
	Star30 - direction
	Phenomenon31 - direction
)
(:init
	(supports instrument0 infrared0)
	(supports instrument0 infrared2)
	(calibration_target instrument0 GroundStation18)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 Star2)
	(calibration_target instrument0 GroundStation7)
	(calibration_target instrument0 Star6)
	(calibration_target instrument0 GroundStation11)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star19)
	(supports instrument1 image3)
	(supports instrument1 spectrograph1)
	(calibration_target instrument1 GroundStation3)
	(calibration_target instrument1 GroundStation18)
	(calibration_target instrument1 Star6)
	(calibration_target instrument1 GroundStation1)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Planet28)
)
(:goal (and
	(pointing satellite0 Planet24)
	(have_image Star20 spectrograph1)
	(have_image Star21 image3)
	(have_image Star22 infrared2)
	(have_image Planet23 infrared2)
	(have_image Planet24 infrared2)
	(have_image Planet25 spectrograph1)
	(have_image Phenomenon26 infrared0)
	(have_image Star27 spectrograph1)
	(have_image Planet28 infrared2)
	(have_image Planet29 infrared0)
	(have_image Star30 image3)
	(have_image Phenomenon31 spectrograph1)
))

)
