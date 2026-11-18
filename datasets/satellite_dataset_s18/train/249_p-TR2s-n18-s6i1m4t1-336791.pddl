(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	satellite2 - satellite
	instrument2 - instrument
	satellite3 - satellite
	instrument3 - instrument
	satellite4 - satellite
	instrument4 - instrument
	satellite5 - satellite
	instrument5 - instrument
	infrared0 - mode
	spectrograph3 - mode
	infrared1 - mode
	infrared2 - mode
	GroundStation0 - direction
	Phenomenon1 - direction
)
(:init
	(supports instrument0 spectrograph3)
	(supports instrument0 infrared2)
	(calibration_target instrument0 GroundStation0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon1)
	(supports instrument1 infrared1)
	(supports instrument1 spectrograph3)
	(supports instrument1 infrared2)
	(calibration_target instrument1 GroundStation0)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon1)
	(supports instrument2 infrared2)
	(supports instrument2 spectrograph3)
	(supports instrument2 infrared1)
	(calibration_target instrument2 GroundStation0)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation0)
	(supports instrument3 infrared1)
	(calibration_target instrument3 GroundStation0)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Phenomenon1)
	(supports instrument4 infrared1)
	(supports instrument4 infrared0)
	(supports instrument4 spectrograph3)
	(calibration_target instrument4 GroundStation0)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Phenomenon1)
	(supports instrument5 infrared1)
	(supports instrument5 infrared0)
	(calibration_target instrument5 GroundStation0)
	(on_board instrument5 satellite5)
	(power_avail satellite5)
	(pointing satellite5 Phenomenon1)
)
(:goal (and
	(pointing satellite1 GroundStation0)
	(pointing satellite2 GroundStation0)
	(have_image Phenomenon1 infrared2)
))

)
