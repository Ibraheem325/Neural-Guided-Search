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
	thermograph2 - mode
	spectrograph0 - mode
	infrared1 - mode
	infrared3 - mode
	GroundStation1 - direction
	Star0 - direction
	GroundStation2 - direction
	Phenomenon3 - direction
	Star4 - direction
)
(:init
	(supports instrument0 infrared3)
	(calibration_target instrument0 GroundStation2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 GroundStation1)
	(supports instrument1 infrared3)
	(calibration_target instrument1 GroundStation1)
	(on_board instrument1 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon3)
	(supports instrument2 thermograph2)
	(supports instrument2 spectrograph0)
	(calibration_target instrument2 GroundStation1)
	(on_board instrument2 satellite2)
	(power_avail satellite2)
	(pointing satellite2 GroundStation1)
	(supports instrument3 infrared3)
	(calibration_target instrument3 Star0)
	(on_board instrument3 satellite3)
	(power_avail satellite3)
	(pointing satellite3 Phenomenon3)
	(supports instrument4 infrared1)
	(calibration_target instrument4 GroundStation2)
	(on_board instrument4 satellite4)
	(power_avail satellite4)
	(pointing satellite4 Phenomenon3)
)
(:goal (and
	(pointing satellite2 Star0)
	(pointing satellite4 GroundStation2)
	(have_image Phenomenon3 thermograph2)
	(have_image Star4 infrared1)
))

)
