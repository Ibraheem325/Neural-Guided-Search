(define (problem strips-sat-x-1)
(:domain satellite)
(:objects
	satellite0 - satellite
	instrument0 - instrument
	satellite1 - satellite
	instrument1 - instrument
	instrument2 - instrument
	satellite2 - satellite
	instrument3 - instrument
	instrument4 - instrument
	image2 - mode
	spectrograph3 - mode
	spectrograph4 - mode
	thermograph1 - mode
	image0 - mode
	GroundStation0 - direction
	Star1 - direction
	Star2 - direction
	Phenomenon3 - direction
	Phenomenon4 - direction
)
(:init
	(supports instrument0 spectrograph3)
	(supports instrument0 thermograph1)
	(calibration_target instrument0 Star2)
	(on_board instrument0 satellite0)
	(power_avail satellite0)
	(pointing satellite0 Phenomenon4)
	(supports instrument1 spectrograph3)
	(supports instrument1 image2)
	(calibration_target instrument1 GroundStation0)
	(supports instrument2 image2)
	(calibration_target instrument2 Star1)
	(on_board instrument1 satellite1)
	(on_board instrument2 satellite1)
	(power_avail satellite1)
	(pointing satellite1 Phenomenon3)
	(supports instrument3 spectrograph3)
	(supports instrument3 image2)
	(calibration_target instrument3 Star1)
	(supports instrument4 spectrograph4)
	(supports instrument4 thermograph1)
	(supports instrument4 image0)
	(calibration_target instrument4 Star2)
	(on_board instrument3 satellite2)
	(on_board instrument4 satellite2)
	(power_avail satellite2)
	(pointing satellite2 Star1)
)
(:goal (and
	(pointing satellite0 Phenomenon4)
	(have_image Phenomenon3 spectrograph4)
	(have_image Phenomenon4 image2)
))

)
