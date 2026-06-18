(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	instrument3 - instrument
	satellite1 - satellite
	instrument4 - instrument
	spectrograph1 - mode
	infrared2 - mode
	infrared0 - mode
	GroundStation10 - direction
	GroundStation9 - direction
	GroundStation6 - direction
	Star8 - direction
	Star5 - direction
	Star7 - direction
	GroundStation1 - direction
	GroundStation4 - direction
	GroundStation3 - direction
	Star11 - direction
	GroundStation12 - direction
	Star0 - direction
	GroundStation13 - direction
	GroundStation2 - direction
	Planet14 - direction
	Star15 - direction
	Phenomenon16 - direction
	Star17 - direction
)
(:init
	(supports instrument0 infrared2)
	(supports instrument0 infrared0)
	(calibration_target instrument0 GroundStation9)
	(supports instrument1 infrared0)
	(supports instrument1 spectrograph1)
	(calibration_target instrument1 Star8)
	(calibration_target instrument1 Star11)
	(calibration_target instrument1 GroundStation6)
	(supports instrument2 infrared0)
	(supports instrument2 spectrograph1)
	(calibration_target instrument2 GroundStation1)
	(calibration_target instrument2 Star7)
	(calibration_target instrument2 Star5)
	(supports instrument3 infrared2)
	(calibration_target instrument3 Star11)
	(calibration_target instrument3 GroundStation3)
	(calibration_target instrument3 GroundStation4)
	(calibration_target instrument3 Star0)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(on_board instrument3 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Star17)
	(supports instrument4 spectrograph1)
	(supports instrument4 infrared2)
	(calibration_target instrument4 GroundStation2)
	(calibration_target instrument4 GroundStation13)
	(calibration_target instrument4 Star0)
	(calibration_target instrument4 GroundStation12)
	(on_board instrument4 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Star15)
)
(:goal (and
	(have_image Planet14 infrared2)
	(have_image Star15 spectrograph1)
	(have_image Phenomenon16 spectrograph1)
	(have_image Star17 infrared0)
))

)
