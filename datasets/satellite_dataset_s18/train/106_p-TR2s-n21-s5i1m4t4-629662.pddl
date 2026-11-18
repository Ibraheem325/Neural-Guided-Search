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
	image2 - mode
	spectrograph1 - mode
	infrared0 - mode
	thermograph3 - mode
	Star0 - direction
	Star2 - direction
	GroundStation1 - direction
	GroundStation3 - direction
	Phenomenon4 - direction
	Phenomenon5 - direction
	Phenomenon6 - direction
)
(:init
	(supports instrument0 thermograph3)
	(calibration_target instrument0 GroundStation1)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation3)
	(supports instrument1 spectrograph1)
	(supports instrument1 thermograph3)
	(calibration_target instrument1 GroundStation1)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon6)
	(supports instrument2 spectrograph1)
	(supports instrument2 infrared0)
	(supports instrument2 image2)
	(calibration_target instrument2 GroundStation1)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Phenomenon4)
	(supports instrument3 thermograph3)
	(supports instrument3 infrared0)
	(calibration_target instrument3 GroundStation3)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Phenomenon5)
	(supports instrument4 spectrograph1)
	(supports instrument4 image2)
	(supports instrument4 thermograph3)
	(calibration_target instrument4 GroundStation3)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Star2)
)
(:goal (and
	(pointing satellite0 Phenomenon6)
	(pointing satellite4 GroundStation1)
	(have_image Phenomenon4 image2)
	(have_image Phenomenon5 image2)
	(have_image Phenomenon6 infrared0)
))

)
