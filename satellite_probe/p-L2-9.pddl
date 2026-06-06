(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	instrument1 - instrument
	instrument2 - instrument
	satellite1 - satellite
	instrument3 - instrument
	instrument4 - instrument
	instrument5 - instrument
	infrared2 - mode
	spectrograph1 - mode
	infrared0 - mode
	Star0 - direction
	GroundStation2 - direction
	GroundStation6 - direction
	GroundStation13 - direction
	Star8 - direction
	GroundStation12 - direction
	Star5 - direction
	Star11 - direction
	GroundStation9 - direction
	GroundStation4 - direction
	GroundStation10 - direction
	Star7 - direction
	GroundStation1 - direction
	GroundStation14 - direction
	GroundStation3 - direction
	Planet15 - direction
	Planet16 - direction
	Star17 - direction
	Star18 - direction
	Phenomenon19 - direction
	Planet20 - direction
	Phenomenon21 - direction
	Planet22 - direction
)
(:init
	(supports instrument0 spectrograph1)
	(calibration_target instrument0 Star8)
	(calibration_target instrument0 GroundStation14)
	(supports instrument1 spectrograph1)
	(supports instrument1 infrared0)
	(calibration_target instrument1 GroundStation12)
	(calibration_target instrument1 Star5)
	(supports instrument2 infrared2)
	(supports instrument2 spectrograph1)
	(supports instrument2 infrared0)
	(calibration_target instrument2 Star5)
	(on_board instrument0 satellite0)
	(on_board instrument1 satellite0)
	(on_board instrument2 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Planet22)
	(supports instrument3 infrared2)
	(calibration_target instrument3 GroundStation10)
	(calibration_target instrument3 GroundStation4)
	(calibration_target instrument3 GroundStation9)
	(calibration_target instrument3 Star11)
	(calibration_target instrument3 GroundStation3)
	(supports instrument4 infrared2)
	(supports instrument4 spectrograph1)
	(supports instrument4 infrared0)
	(calibration_target instrument4 GroundStation1)
	(calibration_target instrument4 GroundStation14)
	(calibration_target instrument4 Star7)
	(supports instrument5 infrared0)
	(supports instrument5 spectrograph1)
	(supports instrument5 infrared2)
	(calibration_target instrument5 GroundStation3)
	(calibration_target instrument5 GroundStation14)
	(on_board instrument3 satellite1)
	(on_board instrument4 satellite1)
	(on_board instrument5 satellite1)
	(power_avail satellite1)
	(pointing satellite1 GroundStation14)
)
(:goal (and
	(pointing satellite1 GroundStation6)
	(have_image Planet15 spectrograph1)
	(have_image Planet16 spectrograph1)
	(have_image Star17 spectrograph1)
	(have_image Star18 infrared0)
	(have_image Phenomenon19 spectrograph1)
	(have_image Planet20 infrared2)
	(have_image Phenomenon21 spectrograph1)
	(have_image Planet22 infrared0)
))

)
