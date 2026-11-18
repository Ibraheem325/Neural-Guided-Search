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
	thermograph0 - mode
	infrared2 - mode
	image3 - mode
	spectrograph1 - mode
	GroundStation1 - direction
	Star0 - direction
	Phenomenon2 - direction
	Planet3 - direction
	Phenomenon4 - direction
	Planet5 - direction
)
(:init
	(supports instrument0 infrared2)
	(calibration_target instrument0 Star0)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation1)
	(supports instrument1 infrared2)
	(supports instrument1 thermograph0)
	(calibration_target instrument1 Star0)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon2)
	(supports instrument2 image3)
	(calibration_target instrument2 Star0)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Planet5)
	(supports instrument3 spectrograph1)
	(supports instrument3 image3)
	(calibration_target instrument3 Star0)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Phenomenon2)
)
(:goal (and
	(pointing satellite3 Phenomenon2)
	(have_image Phenomenon2 spectrograph1)
	(have_image Planet3 infrared2)
	(have_image Phenomenon4 spectrograph1)
	(have_image Planet5 image3)
))

)
